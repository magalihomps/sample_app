require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example user", email: "user@example.com", password: "wordpass", password_confirmation: "wordpass")
  end
  
  test "should be valid" do
    assert @user.valid?
  end

# test = le champ "name" doit être renseigné  
  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

# test = le champ "email" doit être renseigné  
  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

# test = le champ "name" ne doit pas excéder 50 caractères
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

# test = le champ "email" ne doit pas excéder 255 caractères  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

# test = le champ "email" doit correspondre à une adresse valide
  test "email validation should accept valid addresses" do
    valid_adresses = %w[user@example.com USER@foo.COM  A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_adresses.each do |valid_adress|
      @user.email = valid_adress
      assert @user.valid?, "#{valid_adress.inspect} should be valid"
    end
  end

# test = la validation du champ "email" ne doit pas accepter d'adresses invalides
  test "email validation should reject invalid addresses" do
    invalid_adresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_adresses.each do |invalid_adress|
      @user.email = invalid_adress
      assert_not @user.valid?, "#{invalid_adresses.inspect} should be invalid"
    end
  end

# test = le champ "email" doit être unique dans la bdd
# + ne doit pas être sensible à la casse >> magalihomps@gmail.com == MAGALIHOMPS@gMail.com
# >> Pour cela on passe tous les caractères des emails en MAJ
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
# test pour vérifier que l'adresse email est bien enregistrée en bas de casse
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

# Le mot de passe doit faire au moins 6 caractères
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end  

end