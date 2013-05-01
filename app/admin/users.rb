ActiveAdmin.register User do
  menu :priority => 1

  filter :email

  index do
    column :email
    default_actions
  end

  show do
    attributes_table do
      row :email
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "User" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.buttons
  end
end
