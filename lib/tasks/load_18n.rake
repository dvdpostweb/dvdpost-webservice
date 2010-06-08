require 'pp'
namespace :i18n_db do
  desc 'load all translation in yaml files present in the locales directory to the database'
  task :load => :environment do
    Dir["#{RAILS_ROOT}/locales/*yml"].each do |file|
      YAML.load_file(file).each do |locale, translations_hash|
        locale = Locale.find_by_short("#{locale}")
        load_sub_hash_or_create_entry(locale, [], translations_hash)
      end
    end
  end

  def load_sub_hash_or_create_entry(locale, namespace, translations_hash)
    translations_hash.each do |root, sub_hash|
      if sub_hash.respond_to?(:keys)
        namespace << "#{root}"
        load_sub_hash_or_create_entry(locale, namespace, sub_hash)
        puts "#{' ' * namespace.size}done #{namespace.pop}"
      else
        create_or_update_translation(locale.id, namespace, root, sub_hash)
      end
    end
  end

  def create_or_update_translation(locale_id, namespace, tr_key, text)
    namespace_str = namespace.join('.')
    base_attr = {:locale_id => locale_id, :namespace => namespace_str, :tr_key => tr_key}
    translation = Translation.find(:first, :conditions => base_attr)
    
    translation ? translation.update_attribute(:text, text) : Translation.create(base_attr.merge({:text => text}))
  end
end