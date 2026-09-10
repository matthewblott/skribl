class AccountController < EmailAuthController
  def index
  end

  def send_code
    email = params[:email].to_s.strip.downcase

    if email.blank?
      flash.now[:alert] = "Please enter an email address."
      render :new, status: :unprocessable_entity and return
    end

    if User.where.not(id: Current.user.id).exists?(email: email)
      flash.now[:alert] = "An account with that email already exists."
      render :new, status: :unprocessable_entity and return
    end

    otp_secret = User.generate_otp_secret
    session[:email] = email
    session[:otp_secret] = otp_secret

    deliver_otp(email, User.otp_for_secret(otp_secret).now)

    message = "Verification code sent to #{email}."
    redirect_to user_account_verify_code_path, notice: message
    # AlertBroadcaster.broadcast(Current.user.id, "Verification code sent to #{email}.", type: :success)
  end
  
  def verify
    @email = session[:email]
  end

  def verify_code
    email = session[:email]
    otp_secret = session[:otp_secret]

    if email.blank? || otp_secret.blank?
      redirect_to guest_upgrade_path and return
    end

    unless User.otp_for_secret(otp_secret).verify(params[:otp_code], drift_behind: 30)
      flash.now[:alert] = "Invalid or expired code."
      @email = email
      render :verify, status: :unprocessable_entity and return
    end

    # Re-check uniqueness at the point of write, in case it was taken
    # by someone else between send_code and now.
    if User.where.not(id: Current.user.id).exists?(email: email)
      flash.now[:alert] = "An account with that email already exists."
      @email = email
      render :verify, status: :unprocessable_entity and return
    end

    Current.user.update!(email: email, otp_secret: otp_secret, otp_enabled: true)

    session.delete(:otp_secret)
    session.delete(:email)

    # redirect_to user_home_path(Current.user), notice: "Email added — you can now sign in from any device."
    message = "Email added — you can now sign in from any device."

    if is_native_app?
      redirect_to user_account_path, notice: message
    else
      redirect_to user_home_path, notice: message
    end
  end

  def sign_out 
    session_id = cookies.signed[:session_token]
    Session.find_by(id: session_id)&.destroy
    cookies.delete(:session_token)
    cookies.delete(:device_token)
    redirect_to root_path(from_sign_out: true)
  end
  
  def destroy
    Current.user.destroy
    cookies.delete(:device_token)
    redirect_to root_path(from_sign_out: true)
  end

  def download_images
    folder_path = Rails.root.join('uploads', Current.user.id.to_s)
    zip_data = Zip::OutputStream.write_buffer do |zip|
      Dir.glob("#{folder_path}/*.png").each do |file|
        zip.put_next_entry(File.basename(file))
        zip.write(File.read(file))
      end
    end

    send_data zip_data.string, 
      filename: 'images.zip', 
      type: 'application/zip'

  end

end
