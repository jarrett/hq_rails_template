module ApplicationHelper
  def body_class
    params[:controller].gsub('_', '-').gsub('/', '-') + '-' +
    params[:action].gsub('_', '-')
  end
end
