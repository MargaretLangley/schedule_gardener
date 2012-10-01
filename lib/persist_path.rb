module PersistPath

    def store_path
      session[:return_to_path] = request.fullpath
    end

    def clear_path
      session.delete(:return_to_path)
    end



    def redirect_to_stored_path
      redirect_to(session[:return_to_path])
    end

    def redirect_to_stored_path_else_default_path(default_path)
      stored_path? ? redirect_to_stored_path : redirect_to(default_path)
    end

    def stored_path?
      session[:return_to_path].present?
    end

 end