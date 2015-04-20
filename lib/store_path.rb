#
# StorePath
#
# Remembers a path for later usage
#   - save a path while doing another operation
#   - sometimes we want to keep a path and only use it if a condition arises.
#
module StorePath
  # persist path for later usage
  #
  def store_path
    session[:return_to_path] = request.fullpath
  end

  # Remove persisted path
  #
  def clear_store_path
    session.delete(:return_to_path)
  end

  # redirect_to persisted path
  #
  def redirect_to_store_path
    redirect_to(session[:return_to_path])
  end

  # have we persisted a path?
  #
  def store_path?
    session[:return_to_path].present?
  end
end
