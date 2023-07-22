class PublicationsController < ApplicationController
  before_action :set_publication, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action only: [:new, :create] do
    authorize_request(["normal_user", "author", "admin"])
  end

  before_action only: [:edit, :update, :destroy] do
    authorize_request(["normal_user", "author", "admin"]) #solo admin y autor pueden editar actualizar y destruir
  end

  def authorize_request(kind = nil)
    unless kind.include?(current_user.role) || current_user.admin? #Asi el admin tiene acceso a todo
       redirect_to publications_path, notice: "Lamentablemente no estás autorizado para esta acción"
    end
  end

  # GET /publications or /publications.json
  def index
    @publications = Publication.all
  end

  # GET /publications/1 or /publications/1.json
  def show
    @publication = Publication.find(params[:id])
    #@comments = @publication.comments.includes(:user)
    @comment = Comment.new
    @comments = @publication.comments
  end

  # GET /publications/new
  def new
    @publication = Publication.new
  end

  # GET /publications/1/edit
  def edit
  end

  # POST /publications or /publications.json
  def create
    @publication = Publication.new(publication_params)
    @publication.user_id = current_user.id
    @comment = Comment.new
    @comment.user = current_user

    respond_to do |format|
      if @publication.save
        format.html { redirect_to publication_url(@publication), notice: "Publicación creada exitosamente" }
        format.json { render :show, status: :created, location: @publication }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publications/1 or /publications/1.json
  def update
    respond_to do |format|
      if @publication.update(publication_params)
        format.html { redirect_to publication_url(@publication), notice: "Publicación actualizada exitosamente" }
        format.json { render :show, status: :ok, location: @publication }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publications/1 or /publications/1.json
  def destroy
    @publication.destroy

    respond_to do |format|
      format.html { redirect_to publications_url, notice: "Publicación eximinada." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publication
      @publication = Publication.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def publication_params
      params.require(:publication).permit(:title, :image, :description, :user_id, :_destroy)
    end
end
