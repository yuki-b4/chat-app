class MessagesController < ApplicationController
  def index
    @room = Room.find(params[:room_id])
    @message = Message.new
    @messages = @room.messages.includes(:user)
  end

  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_content)
    if @message.save
      redirect_to room_messages_path(@room) #indexに戻り、空のroom_idに紐づいた@messageを作り、それらの情報がはいったparamsが↓
      # フォームから飛ばされるようにredirectする。
    else
      @messages = @room.messages.includes(:user)
      render :index
    end

  end

  private
  def message_content
    params.require(:message).permit(:content).merge(user_id: current_user.id)
  end
end
