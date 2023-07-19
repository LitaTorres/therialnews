require "test_helper"

class PublicationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers #para ocupar el metodo sign_in

  def setup
    @publication = publications(:one)
  end

  test "should get new" do #Pregunta si se abre la pag new
    sign_in users(:one) #pudo iniciar sesión
    get new_publication_path #pudo entrar a la url de new publication
    assert_response :success #y fue exitoso, se pudo visualizar
  end

  test "should create publication" do #si se abre la pag publications
    sign_in users(:one) #1ro iniciar sesión
    assert_difference("Publication.count") do #contar las publicaciones y hacer 1 post enviando los parametros
      post publications_url, params: { publication: { description: @publication.description, image: @publication.image, title: @publication.title, user_id: @publication.user_id } }
    end

    assert_redirected_to publication_path(Publication.last)
  end

  test "should get edit" do
    sign_in users(:one)
    get edit_publication_path(@publication)
    assert_response :success
  end

  test "should update publication" do
    sign_in users(:one)
    patch publication_path(@publication), params: { publication: { description: @publication.description, image: @publication.image, title: @publication.title, user_id: @publication.user_id } }
    assert_redirected_to publication_path(@publication)
  end

  test "should destroy publication" do
    sign_in users(:one)
    assert_difference("Publication.count", -1) do
      delete publication_path(@publication)
    end

    assert_redirected_to publications_path
  end

  test "should get index" do #DATO: tuve qu corregir el _publication donde habia puesto image tag
    sign_in users(:one)
    get publications_path
    assert_response :success
  end

  test "should show publication" do
    sign_in users(:one)
    get publication_path(@publication)
    assert_response :success
  end

end

#Resumiendo: Los test pasaron pero tuve que:
# 1) modificar todas las urls a paths 
# 2) Agregar linea 3 y 4 como la clase del profe (integrar devise al testing)
# 3) definir bien el metodo setup
# 4) incluir el sign_in users ( : one) para obligar a que se inicie sesión
# 5) comenté todos los BEFORE action desde la linea 3 a la 17 en publications controller
# 6) agregué un dependen destroy para que funcionara el testeo en destroy
#7) comenté x siacaso en aplication controler el authorize request 