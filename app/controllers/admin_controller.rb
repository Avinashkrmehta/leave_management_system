class AdminController < ApplicationController
	before_action :authenticate_user!
	before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
  	 @leaves = Leave.all
  	 @users = User.all

  	@leaves = Leave.where(user_id: current_user.id)
    @applied_leaves = Leave.where(status: "applied").where(user_id: current_user.id)
    @approved_leaves = Leave.where(status: "approved").where(user_id: current_user.id)
    @rejected_leaves = Leave.where(status: "rejected").where(user_id: current_user.id)
    @leave_balance = current_user.max_leave - Leave.where(status: "rejected").where(user_id: current_user.id).count
  end

  def leave
  	@leaves = Leave.all
  end

  def leave_request
		@leave = Leave.find(params[:id])
		@leave.status = params[:status]
  	if @leave.save
      UserMailer.leave_request_status(current_user, @leave).deliver_now
  		flash[:notice] = "Status Updated"
  	else
  		flash[:alert] = "Something went wrong can't update status"
  	end
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.password = "password"
    @user.password_confirmation = "password"
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_index_path, notice: 'user was successfully created.' }
        format.json { render :new, status: :created, location: @user }
      else
        flash[:alert] =  @user.errors.full_messages.to_sentence
        format.html { render :new}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_index_path, notice: 'user was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        flash[:alert] =  @user.errors.full_messages.to_sentence
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_index_path, notice: 'user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.fetch(:user, {})
      params.require(:user).permit(:username, :email,:password, :max_leave, :role)
    end  
end
