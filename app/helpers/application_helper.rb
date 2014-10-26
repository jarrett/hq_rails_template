module ApplicationHelper
  def body_class
    params[:controller].gsub('_', '-').gsub('/', '-') + '-' +
    params[:action].gsub('_', '-')
  end
  
  def error_on(obj, attr)
    if obj.errors.include? attr
      content_tag('span', :class => 'error-message') do
        obj.errors[attr].join('; ')
      end
    else
      nil
    end
  end
end
