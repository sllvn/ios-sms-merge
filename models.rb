require 'sequel'

SOURCE = Sequel.connect('sqlite://iphone5sms.db')
TARGET = Sequel.connect('sqlite://iphone6sms.db')

def exclude_prop(obj, keyname)
  obj.select { |k, v| k.to_s != keyname }
end

class SourceHandle < Sequel::Model(SOURCE[:handle])
  many_to_many :source_chats, key: :ROWID, left_key: :handle_id, right_key: :chat_id, join_table: :chat_handle_join
end

class SourceChat < Sequel::Model(SOURCE[:chat])
  many_to_many :source_handles, key: :ROWID, left_key: :chat_id, right_key: :handle_id, join_table: :chat_handle_join
  many_to_many :source_messages, key: :ROWID, left_key: :chat_id, right_key: :message_id, join_table: :chat_message_join
end

class SourceMessage < Sequel::Model(SOURCE[:message])
  many_to_many :source_chats, key: :ROWID, left_key: :message_id, right_key: :chat_id, join_table: :chat_message_join
  many_to_many :source_attachments, key: :ROWID, left_key: :message_id, right_key: :attachment_id, join_table: :message_attachment_join
end

class SourceAttachment < Sequel::Model(SOURCE[:attachment])
  many_to_many :source_messages, key: :ROWID, left_key: :attachment_id, right_key: :message_id, join_table: :message_attachment_join
end

class TargetHandle < Sequel::Model(TARGET[:handle])
  many_to_many :target_chats, key: :ROWID, left_key: :handle_id, right_key: :chat_id, join_table: :chat_handle_join
end

class TargetChat < Sequel::Model(TARGET[:chat])
  many_to_many :target_handles, key: :ROWID, left_key: :chat_id, right_key: :handle_id, join_table: :chat_handle_join
  many_to_many :target_messages, key: :ROWID, left_key: :chat_id, right_key: :message_id, join_table: :chat_message_join
end

class TargetMessage < Sequel::Model(TARGET[:message])
  many_to_many :target_chats, key: :ROWID, left_key: :message_id, right_key: :chat_id, join_table: :chat_message_join
  many_to_many :target_attachments, key: :ROWID, left_key: :message_id, right_key: :attachment_id, join_table: :message_attachment_join
end

class TargetAttachment < Sequel::Model(TARGET[:attachment])
  many_to_many :target_messages, key: :ROWID, left_key: :attachment_id, right_key: :message_id, join_table: :message_attachment_join
end
