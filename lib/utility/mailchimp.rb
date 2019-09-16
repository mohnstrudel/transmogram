module Utility
  class Mailchimp
    def self.subscribe(resource)
      password = resource&.initial_password
      email = resource&.email
      firstname = resource.nickname.present? ? resource.nickname : "Firstname #{resource.id}"
      lastname = "Lastname #{resource.id}"

      list = "cf55c52ea7"
      begin
        Gibbon::Request.lists(list).members.create(body: {email_address: email, status: "subscribed", merge_fields: {FNAME: firstname, LNAME: lastname, PHONE: password}})
      rescue Gibbon::MailChimpError => e
        if e.title == "Invalid Resource"
          password = "123xyz"
          retry
        elsif e.title == "Forgotten Email Not Subscribed"
          puts "User was already on the list, unsubscribed then. Users info: #{resource.inspect} "
        else
          puts "Gibbon::Request encountered an #{e} exception. Full error detail: #{e.message}"
        end
      end
    end
  end
end