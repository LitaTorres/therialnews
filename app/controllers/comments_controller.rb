class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]

  before_action only: [:new, :create] do
    authorize_request(["normal_user", "author", "admin"])
  end

  before_action only: [:edit, :update, :destroy] do
    authorize_request([ "normal_user", "admin", "author"]) #solo admin y autor pueden editar actualizar y destruir
  end

  def authorize_request(kind = nil)
    unless kind.include?(current_user.role) || current_user.admin? #Asi el admin tiene acceso a todo
       redirect_to publications_path, notice: "No estás autorizado para esta accion"
    end
  end

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit #ESTE PEDAZO DE EDIT FUE AGREGAFO HOY 19 DE JULIO
    unless current_user.admin? || current_user.id == @comment.user_id
      redirect_to publication_path(@comment.publication), notice: "No estás autorizado para editar este comentario."
    end
  end

  # POST /comments or /comments.json
  def create
    #@comment = Comment.new(comment_params)
    @publication = Publication.find(params[:publication_id])
    @comment = @publication.comments.build(comment_params)
    @comment.user = current_user


    respond_to do |format|
      if @comment.save
        format.html { redirect_to publication_path(@publication), notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to publications_path(@publication), notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    unless current_user.admin? || current_user.id == @comment.user_id
      redirect_to publication_path(@comment.publication), notice: "No estás autorizado para eliminar este comentario."
      return
    end

    @comment.destroy

    respond_to do |format|
      format.html { redirect_to publication_path, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content, :user_id, :publication_id)
    end
end
