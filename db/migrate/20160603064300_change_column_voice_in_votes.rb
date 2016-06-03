class ChangeColumnVoiceInVotes < ActiveRecord::Migration
  def change
    change_column :votes, :voice, 'integer USING CAST(voice AS integer)'
  end
end
