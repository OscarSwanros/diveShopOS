# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = users(:owner_maria)
    @manager = users(:manager_carlos)
    @staff = users(:staff_ana)
  end

  # --- Index ---

  test "index requires authentication" do
    get users_path
    assert_redirected_to new_session_path
  end

  test "index lists users for signed-in user" do
    sign_in @owner
    get users_path
    assert_response :success
    assert_select "table"
  end

  # --- Show ---

  test "show displays user details" do
    sign_in @owner
    get user_path(@staff)
    assert_response :success
    assert_select "h1", @staff.name
  end

  # --- New ---

  test "owner can access new user form" do
    sign_in @owner
    get new_user_path
    assert_response :success
  end

  test "staff cannot access new user form" do
    sign_in @staff
    get new_user_path
    assert_response :forbidden
  end

  # --- Create ---

  test "owner can create a user" do
    sign_in @owner
    assert_difference "User.count", 1 do
      post users_path, params: { user: {
        name: "New Staffer",
        email_address: "new@reefdivers.com",
        password: "password123",
        password_confirmation: "password123",
        role: "staff"
      } }
    end
    new_user = User.find_by(email_address: "new@reefdivers.com")
    assert_redirected_to user_path(new_user)
    follow_redirect!
    assert_select "h1", "New Staffer"
  end

  test "staff cannot create a user" do
    sign_in @staff
    post users_path, params: { user: {
      name: "Sneaky",
      email_address: "sneaky@reefdivers.com",
      password: "password123",
      password_confirmation: "password123",
      role: "staff"
    } }
    assert_response :forbidden
  end

  test "create re-renders form on validation error" do
    sign_in @owner
    assert_no_difference "User.count" do
      post users_path, params: { user: {
        name: "",
        email_address: "bad",
        password: "x",
        role: "staff"
      } }
    end
    assert_response :unprocessable_entity
  end

  # --- Edit ---

  test "owner can edit any user" do
    sign_in @owner
    get edit_user_path(@staff)
    assert_response :success
  end

  test "user can edit themselves" do
    sign_in @staff
    get edit_user_path(@staff)
    assert_response :success
  end

  test "staff cannot edit other users" do
    sign_in @staff
    get edit_user_path(@manager)
    assert_response :forbidden
  end

  # --- Update ---

  test "owner can update a user" do
    sign_in @owner
    patch user_path(@staff), params: { user: { name: "Updated Name" } }
    @staff.reload
    assert_redirected_to user_path(@staff)
    assert_equal "Updated Name", @staff.name
  end

  test "update with blank password does not change password" do
    sign_in @owner
    original_digest = @staff.password_digest
    patch user_path(@staff), params: { user: { name: "Same Password", password: "", password_confirmation: "" } }
    @staff.reload
    assert_redirected_to user_path(@staff)
    assert_equal original_digest, @staff.password_digest
  end

  # --- Destroy ---

  test "owner can destroy other users" do
    sign_in @owner
    assert_difference "User.count", -1 do
      delete user_path(@staff)
    end
    assert_redirected_to users_path
  end

  test "owner cannot destroy themselves" do
    sign_in @owner
    delete user_path(@owner)
    assert_response :forbidden
  end

  test "staff cannot destroy users" do
    sign_in @staff
    delete user_path(@manager)
    assert_response :forbidden
  end

  private

  def sign_in(user)
    post session_path, params: { email_address: user.email_address, password: "password123" }
  end
end
