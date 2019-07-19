class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :inactive]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  def section
    @accounts = Account.active.order(datetime: :desc)
    @account_sections = @accounts
      .group_by {|account| account.datetime.beginning_of_month.strftime('%Y-%m')}
      .map do |month, accounts|
        { title: month, data: accounts, total: view_context.number_to_currency(accounts.map(&:change).sum, locale: 'cn') }
      end
    render json: @account_sections
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html {redirect_to @account, notice: 'Account was successfully created.'}
        format.json {render :show, status: :created, location: @account}
      else
        format.html {render :new}
        format.json {render json: @account.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html {redirect_to @account, notice: 'Account was successfully updated.'}
        format.json {render :show, status: :ok, location: @account}
      else
        format.html {render :edit}
        format.json {render json: @account.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html {redirect_to accounts_url, notice: 'Account was successfully destroyed.'}
      format.json {redirect_to action: :section, status: 303}
    end
  end

  def inactive
    @account.update(active: false)
    render json: { success: true }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    if request.format.ref === :json
      JSON.parse(request.body.read)
    else
      params.require(:account).permit(:type, :sub_type, :merchant, :change, :currency, :comments, :datetime)
    end
  end
end
