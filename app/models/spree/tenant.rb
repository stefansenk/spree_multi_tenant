class Spree::Tenant < ActiveRecord::Base

  validates_presence_of :domain
  validates_uniqueness_of :domain
  
  validates_presence_of :code
  validates_uniqueness_of :code


  def templates_base_path
    File.join Rails.root, 'app', 'tenants', code
  end

  def create_templates_path
    views = File.join templates_base_path, 'views'
    FileUtils.mkdir_p views unless File.exist? views
  end

end
