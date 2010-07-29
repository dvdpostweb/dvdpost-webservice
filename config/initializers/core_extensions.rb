# Remove attribute from errors.full_messages
class ActiveRecord::Error
  def generate_full_message(options = {})
    keys = [
      :"full_messages.#{@message}",
      :'full_messages.format',
      '{{message}}'
    ]

    options.merge!(:default => keys, :message => self.message)
    I18n.translate(keys.shift, options)
  end
end
