require "paper_trail/version_concern"

module PaperTrail
  # This is the default ActiveRecord model provided by PaperTrail. Most simple
  # applications will only use this and its partner, `VersionAssociation`, but
  # it is possible to sub-class, extend, or even do without this model entirely.
  # See the readme for details.
  class Version < ::ActiveRecord::Base
    before_create :record_signup

    private
    def valid_json?(json)
      begin
        JSON.parse(json, {:quirks_mode => true})
        return true
      rescue => e
        return false
      end
    end

    private
    def record_signup
      logg = ::Rails::logger
      if valid_json?(self.object)
        data = JSON.parse(self.object, {:quirks_mode => true})
      else
        data = self.object.to_s
      end
      puts "version chnaged................"
      logg.tagged(:version) do
        lodata = {
          "item_id" => self.item_id,
          "item_type" => self.item_type,
          "event" => self.event,
          "whodunnit" => self.whodunnit,
          "changes" => self.changeset,
          "object" => data
        }
        logg.info(lodata)
     end
    end

    include PaperTrail::VersionConcern
  end
end
