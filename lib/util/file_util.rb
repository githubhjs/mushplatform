require 'fileutils'
module FileUtil
  class << self
   
    def cp_r(form_path,to_path)
      Dir.glob("#{form_path}/*") do |f_path|
        if File.directory?(f_path)
          cp_r(f_path,"#{to_path}/#{File.basename(f_path)}") if File.stat(f_path).readable?
        elsif File.file?(f_path) && File.readable?(f_path)
          FileUtils.makedirs(to_path) unless File.directory?(to_path)
          FileUtils.cp(f_path,to_path)
        end
      end
    end
    
  end  
  
end

#FileUtil.cp_r("/home/liuikai/team/mushplatform/lib", "/home/liuikai/team/hehe")
