module BootstrapHelper
  def alert(*args, &block)
    options = args.extract_options!
    options.reverse_merge! type: :info
    
    if block_given?
      message = capture(&block)
    else
      message = args.first
    end
    
    alert_classes = ['alert', "alert-#{options[:type]}"]
    if options[:dismissible]
      alert_classes << 'alert-dismissible'
    end
    
    content_tag 'div', class: alert_classes.join(' '), role: 'alert' do
      out = ''.html_safe
      if options[:dismissible]
        out << content_tag('button', type: 'button', class: 'close', 'data-dismiss' => 'alert') do
          content_tag('span', '&times;'.html_safe, 'aria-hidden' => true) +
          content_tag('span', 'Close', class: 'sr-only')
        end
      end
      out + content_tag('div', message)
    end
  end
end

class ActionView::Helpers::FormBuilder
  def error_on(attr, options = {})
    options.reverse_merge! capitalize: true
    if object.errors.include? attr
      @template.content_tag('span', class: 'help-block') do
        object.errors[attr].map do |error|
          options[:capitalize] ? error.capitalize : error
        end.join(options[:capitalize] ? '. ': '; ')
      end
    else
      nil
    end
  end
  
  def group(attr)
    classes = ['form-group']
    if object.errors.include? attr
      classes << 'has-error'
    end
    @template.content_tag('div', class: classes.join(' ')) do
      yield
    end
  end
end