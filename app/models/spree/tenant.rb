class Spree::Tenant < ActiveRecord::Base

  validates :domain, presence: true 
  validates :domain, uniqueness: true
  
  validates :code, presence: true
  validates :code, uniqueness: true

  validate :domain_should_be_valid


  def domain_should_be_valid
    begin
      uri = URI.parse('http://'+domain)
      rescue Exception => e   
        errors.add(:domain, "This domain name is invalid")
    end
  end

  def templates_base_path
    File.join Rails.root, 'app', 'tenants', code
  end

  def create_template_and_assets_paths
    views = File.join templates_base_path, 'views'
    FileUtils.mkdir_p views unless File.exist? views

    images = File.join Rails.root, 'app','assets', 'images', 'tenants', code
    FileUtils.mkdir_p images unless  File.exist? images

    css_files = File.join Rails.root, 'app','assets', 'stylesheets', 'tenants'
    FileUtils.mkdir_p css_files unless  File.exist? css_files
    FileUtils.touch File.join(css_files, "#{code}.css")

    js_files = File.join Rails.root, 'app','assets', 'javascripts', 'tenants'
    FileUtils.mkdir_p js_files unless  File.exist? js_files
    FileUtils.touch File.join(js_files, "#{code}.js")
  end

  private

end
