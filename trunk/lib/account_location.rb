module AccountLocation
  
  def self.included(controller)
    controller.helper_method(:account_domain, :account_subdomain, :account_host, :account_url)
  end

  protected

  def default_account_subdomain
#    @account.username if @account && @account.respond_to?(:username)
   "www"
  end

  def account_url(subdomain = default_account_subdomain, use_ssl = request.ssl?)
    (use_ssl ? "https://" : "http://") + account_host(subdomain)
  end

  def account_host(subdomain = default_account_subdomain)
    account_host = []
    account_host << subdomain
    account_host << account_domain
    account_host.join(".")
  end

  def account_domain
    domain = []
    domain << request.subdomains[1..-1] if request.subdomains.size > 1
    domain << request.domain + request.port_string
    domain.join(".")
  end

  def account_subdomain
    request.subdomains.first
  end

  def assett_domain
    "http://www.#{request.domain}#{request.port_string}"
  end
   
  
end

