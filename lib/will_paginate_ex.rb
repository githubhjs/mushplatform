module WillPaginate

  class LinkRenderer

    protected

    def page_link(page, text, attributes = {})
      debugger
      url_options = ex_url_param.blank? ? url_for(page): generate_url(page)
      url_options.gsub!(/\/1$/,'/') if page == 1
      @template.link_to(text,url_options , attributes)      
    end

    def generate_url(page)
      unless (url = ex_url_param).blank?
        return page <= 1 ? url : "#{url}/page/#{page}"
      end
      return nil
    end

    def ex_url_param
      (@options||{})[:url]
    end

  end
end