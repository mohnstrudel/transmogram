module Utility
  class Mailchimp
    def self.subscribe(resource)
      password = resource&.initial_password
      email = resource&.email
      firstname = resource.nickname.present? ? resource.nickname : "Firstname #{resource.id}"
      lastname = "Lastname #{resource.id}"

      list = "cf55c52ea7"
      Gibbon::Request.lists(list).members.create(body: {email_address: email, status: "subscribed", merge_fields: {FNAME: firstname, LNAME: lastname, PHONE: password}})
    end
  end
end