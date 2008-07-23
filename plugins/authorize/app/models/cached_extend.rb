module CachedExtend
  
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def find(*args)
      if args.size == 1 &&  args.first.to_s =~ /\A\d+\Z/
        if CachedModel.use_memcache?  
          record = Cache.get "active_record:#{name}:#{args.first}"  
          #return cached model  
          return record unless record.nil?  
          #call super find  
          record = super  
          #store in memcache  
          record.cache_store
          return record  
        end  
      end
      args[0] = args.first.to_i if args.first =~ /\A\d+\Z/
      # Only handle simple find requests.  If the request was more complicated,
      # let the base class handle it, but store the retrieved records in the
      # local cache in case we need them later.
      if args.length != 1 or not Fixnum === args.first then
        # Rails requires multiple levels of indirection to look up a record
        # First call super
        records = super
        # Then, if it was a :all, just return
        return records if args.first == :all
        return records if RAILS_ENV == 'test'
        case records
        when Array then
          records.each { |r| r.cache_store }
        end
        return records
      end
      return super
#    rescue
#      return super
    end
    
  end
  
end
