require 'test_helper'
include Devise::TestHelpers

class BankAccountsControllerTest < ActionController::TestCase
  setup do
    
    sign_in users(:alexandre)
    @bank_account = bank_accounts(:one)
    @bank_account_with_uid = bank_accounts(:two)
    @organizer_active = organizers(:utopicos_active)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bank_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should create bank_account format to send to new remote account" do
    skip("create")
    post :create, bank_account: { accountCheckNumber: @bank_account.accountCheckNumber, accountNumber: @bank_account.accountNumber, agencyCheckNumber: @bank_account.agencyCheckNumber, agencyNumber: @bank_account.agencyNumber, bankNumber: @bank_account.bankNumber, doc_number: @bank_account.doc_number, doc_type: @bank_account.doc_type, fullname: @bank_account.fullname, organizer_id: @organizer_active.id, bankType: @bank_account.bankType }
    assert_equal BankAccount.last.account_info["bankNumber"], "237"
    assert_equal BankAccount.last.account_info["agencyNumber"], "12345"
    assert_equal BankAccount.last.account_info["agencyCheckNumber"], "0"
    assert_equal BankAccount.last.account_info["accountNumber"], "12345678"
    assert_equal BankAccount.last.account_info["accountCheckNumber"], "7"
    assert_equal BankAccount.last.account_info["type"], "CHECKING"
    assert_equal BankAccount.last.account_info["holder"]["taxDocument"]["type"], "CPF"
    assert_equal BankAccount.last.account_info["holder"]["taxDocument"]["number"], "22222222222"
    assert_equal BankAccount.last.account_info["holder"]["fullname"], "Teste Moip"
    
    headers = {
      :authorization => 'OAuth 65a0331eba0e4f11b8f738a313d6369e_v2'
    }
     
    response = RestClient.delete "https://sandbox.moip.com.br/v2/bankaccounts/#{BankAccount.last.uid}", headers
    
  end

  test "should create bank_account" do
    skip("create bank account")
    assert_difference('BankAccount.count') do
      post :create, bank_account: { accountCheckNumber: @bank_account.accountCheckNumber, accountNumber: @bank_account.accountNumber, agencyCheckNumber: @bank_account.agencyCheckNumber, agencyNumber: @bank_account.agencyNumber, bankNumber: @bank_account.bankNumber, doc_number: @bank_account.doc_number, doc_type: @bank_account.doc_type, fullname: @bank_account.fullname, organizer_id: @organizer_active.id, bankType: @bank_account.bankType }
    end
    
    @ba = BankAccount.last
    
    assert @ba.uid.present?, "should uid present after create"

    assert_redirected_to bank_account_path(assigns(:bank_account))
    
    headers = {
      :authorization => 'OAuth 65a0331eba0e4f11b8f738a313d6369e_v2'
    }
     
    response = RestClient.delete "https://sandbox.moip.com.br/v2/bankaccounts/#{@ba.uid}", headers
  end

  test "should show bank_account" do
    get :show, id: @bank_account
    assert_response :success
  end

  test "should get edit" do
    skip("edit bank account")
    get :edit, id: @bank_account
    assert_response :success
  end

  test "should update bank_account" do
    skip("update account")
    patch :update, id: @bank_account, bank_account: { accountCheckNumber: @bank_account.accountCheckNumber, accountNumber: @bank_account.accountNumber, agencyCheckNumber: @bank_account.agencyCheckNumber, agencyNumber: @bank_account.agencyNumber, bankNumber: @bank_account.bankNumber, doc_number: @bank_account.doc_number, doc_type: @bank_account.doc_type, fullname: @bank_account.fullname, organizer_id: @organizer_active.id, bankType: @bank_account.bankType, uid: @bank_account.uid }
    assert_redirected_to bank_account_path(assigns(:bank_account))
  end

  test "should destroy bank_account" do
    skip("destroy")
    assert_difference('BankAccount.count', -1) do
      delete :destroy, id: @bank_account
    end
    assert_redirected_to bank_accounts_path
  end
  test "should destroy in remote account when destroy" do
    ActiveResource::HttpMock.respond_to do |mock|
      mock.delete '', {}, '', 200
    end
    assert_difference('BankAccount.count', -1) do
      delete :destroy, id: @bank_account_with_uid.id
    end
    assert_equal flash[:notice], 'A conta foi removida remotamente'
    assert_redirected_to bank_accounts_path
  end
end
