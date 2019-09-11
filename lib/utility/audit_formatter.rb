module Utility
  class AuditFormatter
    def build
      # Possible input:
      # #<Audited::Audit id: 2, auditable_id: 66, auditable_type: "Post", associated_id: 1, associated_type: "User", user_id: 1,
      # user_type: "User", username: nil, action: "create", audited_changes: {"slug"=>"dury-dury-durydan", "title"=>"Dury dury durydan",
      # "user_id"=>1, "description"=>"monk in plate", "armor_type_id"=>4, "class_type_id"=>6}, version: 1, comment: nil, remote_address: "::1",
      # request_uuid: "75b1236c-1346-4fad-93b2-3f0b171cf375", created_at: "2019-09-11 15:00:59">
      collection.pluck(:auditable_type, :action, :created_at)
    end
  end
end