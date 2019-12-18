function get_token(user as String, password as String)
  url = "Users/AuthenticateByName?format=json"
  req = APIRequest(url)

  json = postJson(req, "Username=" + user + "&Pw=" + password.replace("&", "%26"))

  if json = invalid then return invalid

  userdata = CreateObject("roSGNode", "UserData")
  userdata.json = json

  userdata.callFunc("setActive")
  userdata.callFunc("saveToRegistry")
  return userdata
end function

function AboutMe()
  id = get_setting("active_user")
  url = Substitute("Users/{0}", id)
  resp = APIRequest(url)
  return getJson(resp)
end function

function SignOut()
  if get_setting("active_user") <> invalid
    unset_user_setting("token")
  end if
  unset_setting("active_user")
end function

function AvailableUsers()
  users = parseJson(get_setting("available_users", "[]"))
  return users
end function

function PickUser(id as string)
  this_user = invalid
  for each user in AvailableUsers()
    if user.id = id then this_user = user
  end for
  if this_user = invalid then return invalid
  set_setting("active_user", this_user.id)
  set_setting("server", this_user.server)
  set_setting("port", this_user.port)
end function

function RemoveUser(id as string)
  user = CreateObject("roSGNode", "UserData")
  user.id = id
  user.callFunc("removeFromRegistry")

  if get_setting("active_user") = id then SignOut()
end function

function ServerInfo()
  url = "System/Info/Public"
  resp = APIRequest(url)
  return getJson(resp)
end function
