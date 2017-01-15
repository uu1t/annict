# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  permits :username, :email, :password, model_name: "User"

  def new
    @user = User.new_with_session({}, session)
  end

  def create(user)
    @user = User.new(user).build_relations

    return render(:new) unless @user.valid?

    @user.save
    keen_client.users.create(@user)

    bypass_sign_in(@user)

    flash[:info] = t("registrations.create.confirmation_mail_has_sent")
    redirect_to after_sign_in_path_for(@user)
  end
end
