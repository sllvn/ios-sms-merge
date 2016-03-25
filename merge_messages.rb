#!/usr/bin/env ruby

require './models'

def exclude_prop(obj, keyname)
  obj.select { |k, v| k.to_s != keyname }
end

source_handles = SourceHandle.all
source_handles.each do |source_handle|
  target_handle = TargetHandle.find(id: source_handle.id, service: source_handle.service)
  if target_handle
    puts "found handle"
  else
    puts "handle not found, creating..."
    new_props = exclude_prop(source_handle.values, 'ROWID')
    target_handle = TargetHandle.create(new_props)
  end

  source_handle.source_chats.each do |source_chat|
    # TODO: correctly set chat.account_id
    target_chat = TargetChat.find(guid: source_chat.guid)
    if target_chat
      puts "found existing chat"
    else
      puts "existing chat not found, creating..."
      new_props = exclude_prop(source_chat.values, 'ROWID')
      target_chat = TargetChat.create(new_props)
      target_chat.add_target_handle(target_handle)
    end

    source_chat.source_messages.each do |source_message|
      # TODO: correctly set message.account_guid
      target_message = TargetMessage.find(guid: source_message.guid)
      if target_message
        puts "found existing message"
      else
        puts "could not find message, creating..."
        new_props = exclude_prop(source_message.values, 'ROWID')
        new_props[:handle_id] = target_handle.ROWID
        target_message = TargetMessage.create(new_props)
        target_message.add_target_chat(target_chat)
      end

      source_message.source_attachments.each do |source_attachment|
        target_attachment = TargetAttachment.find(guid: source_attachment.guid)
        if target_attachment
          puts "found existing attachment"
        else
          puts "could not find attachment, creating..."
          new_props = exclude_prop(source_attachment.values, 'ROWID')
          target_attachment = TargetAttachment.create(new_props)
          target_attachment.add_target_message(target_message)
        end
      end
    end
  end
end

