local group

RegisterNetEvent("es_admin:setGroup")

AddEventHandler("es_admin:setGroup", function(g)
    print("group setted " .. g)
    group = g
end)

RegisterNetEvent("sendMessageAdmin")
AddEventHandler("sendMessageAdmin", function(id, name, message)
      TriggerServerEvent("getadmin")
      local myId = PlayerId()
      local pid = GetPlayerFromServerId(id)

      if pid == myId then
          TriggerEvent("chat:addMessage", {
          template = '<div style="padding: 0.3vw; margin: 1.0vw; background-color: rgba(0,0,0,0.5); border-radius: 4px;"><i class="fas fa-user-circle"></i>^3 {0}: ^8{1}</div>',
          args = {name, message}})
      elseif group ~= "user" and pid ~= myId then
          TriggerEvent("chat:addMessage", {
          template = '<div style="padding: 0.3vw; margin: 1.0vw; background-color: rgba(0,0,0,0.5); border-radius: 4px;"><i class="fas fa-user-circle"></i>^3 {0}: ^8{1}</div>',
          args = {name, message}})
    end
end)
