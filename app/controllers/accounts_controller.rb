class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :inactive]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.includes(:user).order(datetime: :desc)
  end

  def section
    keyword = params[:keyword]
    anchor = params[:anchor]
    type = params[:type]
    @accounts = if keyword
                  types = Account.types.select { |enum, _| enum =~ %r(#{keyword}) }.values
                  Account.joins(:user).where(type: types)
                    .or(Account.joins(:user).where('sub_type like ?', "%#{keyword}%"))
                    .or(Account.joins(:user).where('merchant like ?', "%#{keyword}%"))
                    .or(Account.joins(:user).where('comments like ?', "%#{keyword}%"))
                    .or(Account.joins(:user).where('users.username like ?', "%#{keyword}%"))
                else
                  Account.all
                end
    @accounts = @accounts.active.includes(:user).order(datetime: :desc)
    @paged_accounts = anchor ? @accounts.where('datetime < ?', Time.at(anchor.to_f)).limit(100) : @accounts.limit(100)
    @account_sections = @paged_accounts
                          .group_by { |account| account.datetime.getlocal.strftime(type == 'day' ? '%Y-%m-%d' : '%Y-%m') }
                          .map do |title, accounts|
      type == 'day' ?
        { title: title, data: accounts.as_json(methods: :username), total: @accounts.day_trunc(title).sum(:change) } :
        { title: title, data: accounts.as_json(methods: :username), total: @accounts.month_trunc(title).sum(:change) }
    end
    render json: { accounts: @account_sections,
                   anchor: @paged_accounts.last&.datetime&.to_f,
                   end_reached: @paged_accounts.last == @accounts.last }
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
    @account.user = @user

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { redirect_to action: :section, status: 303 }
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
    account = if request.format.ref === :json
                ActionController::Parameters.new(JSON.parse(request.body.read))
              else
                params.require(:account)
              end
    account.permit(:type, :sub_type, :merchant, :change, :currency, :comments, :datetime)
  end
end
