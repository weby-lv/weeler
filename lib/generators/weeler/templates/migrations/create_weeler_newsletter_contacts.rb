class CreateWeelerNewsletterContacts < ActiveRecord::Migration
  def change
    create_table :weeler_newsletter_contacts do |t|
      t.string :full_name
      t.string :email

      t.timestamps
    end
    add_index :weeler_newsletter_contacts, :full_name
    add_index :weeler_newsletter_contacts, :email
  end
end
