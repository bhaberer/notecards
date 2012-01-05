module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?
   
    class_name = resource.class.model_name.human.downcase
    
    messages = resource.errors.map do |attr, error| 
      content_tag :li, :id => "#{class_name}_#{attr}_error",
                       :for => "#{class_name}_#{attr}" do 
        simple_format('&#9654;') +
        attr.to_s.capitalize + ' ' +  
        error
      end
    end
    messages = messages.join
    
    html = <<-HTML
    <div id="error_explanation">
      <ul>#{messages}</ul>
    </div>
    HTML
                                      
    html.html_safe 
  end
end
