require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example user", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end

# test = le champ "name" doit tre renseign  
  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

# test = le champ "email" doit tre renseign  
  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

# test = le champ "name" ne doit pas excder 50 caractres
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

# test = le champ "email" ne doit pas excder 255 caractres  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

# test = le champ "email" doit correspondre ˆ une adresse valide
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

# test = le champ "email" doit tre unique dans la bdd
# + ne doit pas tre sensible ˆ la casse >> magalihomps@gmail.com == MAGALIHOMPS@gMail.com
# >> Pour cela on passe tous les caractres des emails en MAJ
  test "email adresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

# Le mot de passe doit faire au moins 6 caractres
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end  

end