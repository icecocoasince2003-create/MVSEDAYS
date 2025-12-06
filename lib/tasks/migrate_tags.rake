namespace :db do
    desc "Migrate journals.tag to tags table"
    task migrate_tags: :environment do
      Journal.find_each do |journal|
        next if journal.tag.blank?
        
        tag_names = journal.tag.split(/[,、]/).map(&:strip).reject(&:blank?)
        
        tag_names.each do |tag_name|
          tag = Tag.find_or_create_by(name: tag_name.downcase)
          JournalTagRelation.find_or_create_by(journal: journal, tag: tag)
        end
        
        puts "Migrated tags for Journal ##{journal.id}: #{tag_names.join(', ')}"
      end
      
      puts "Migration completed!"
    end
  end