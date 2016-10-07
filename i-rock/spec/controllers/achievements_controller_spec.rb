require "rails_helper"

describe AchievementsController do

  shared_examples "public access to achievements" do
    let(:achievement) { instance_double(Achievement) }

    describe "GET index" do
      before do
        allow(Achievement).to receive(:get_public_achievements) { [achievement] }
      end

      it "renders :index template" do
        get :index
        expect(response).to render_template(:index)
      end

      it "assigns public achievements to template" do
        get :index
        expect(assigns(:achievements)).to eq([achievement])
      end
    end

    describe "GET show" do
      before do
        allow(Achievement).to receive(:find) { achievement }
      end

      it "renders :show template" do
        get :show, params: { id: achievement }
        expect(response).to render_template(:show)
      end

      it "assigns requested achievement to @achievement" do
        get :show, params: { id: achievement }
        expect(assigns(:achievement)).to eq(achievement)
      end
    end
  end

  describe "guest user" do
    it_behaves_like "public access to achievements"

    let(:achievement) { instance_double(Achievement) }

    before do
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
    end

    describe "GET new" do
      it "redirects to login page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST create" do
      it "redirects to login page" do
        post :create, params: { achievement: { title: "title" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET edit" do
      it "redirects to login page" do
        get :edit, params: { id: achievement }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "PUT update" do
      it "redirects to login page" do
        put :update, params: { id: achievement, achievement: { title: "New title"} }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "DELETE destroy" do
      it "redirects to login page" do
        delete :destroy, params: { id: achievement }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "authenticated user" do
    it_behaves_like "public access to achievements"

    let(:user) { instance_double(User) }
    let(:achievement) { instance_double(Achievement) }
    
    before do
      allow(controller).to receive(:authenticate_user!) { true }
      allow(controller).to receive(:current_user) { user }
    end

    describe "GET new" do
      before do
        allow(Achievement).to receive(:new) { achievement }
      end

      it "renders :new template" do
        get :new
        expect(response).to render_template(:new)
      end

      it "assigns new Achievement to @achievement" do
        get :new
        expect(assigns(:achievement)).to eq(achievement) 
      end
    end

    describe "POST create" do
      let(:achievement_params) { ActionController::Parameters.new(title: "title") }
      let(:params) { { title: "title" } }
      let(:create_achievement) { instance_double(CreateAchievement) }

      before do
        allow(CreateAchievement).to receive(:new) { create_achievement }
        allow(create_achievement).to receive(:create)
        allow(create_achievement).to receive(:created?)
        allow(create_achievement).to receive(:achievement) { achievement }
      end

      it "sends create message to CreateAchievement" do
        expect(CreateAchievement).to receive(:new).with(achievement_params, user)
        post :create, params: { achievement: params }
      end

      context "achievement is created" do
        before do
          allow(create_achievement).to receive(:created?) { true }
        end

        it "redirects" do
          post :create, params: { achievement: params }
          expect(response.status).to eq(302)
        end
      end

      context "achievement is not created" do
        before do
          allow(create_achievement).to receive(:created?) { false }
        end

        it "render :new template" do
          post :create, params: { achievement: params }
          expect(response).to render_template(:new)
        end

        it "assigns achievement to template" do
          post :create, params: { achievement: params }
          expect(assigns(:achievement)).to eq(achievement)
        end
      end
    end

    context "is not the owner of the achievement" do
      before do
        allow(achievement).to receive(:user) { nil }
        allow(Achievement).to receive(:find) { achievement }
      end

      describe "GET edit" do
        it "redirects to achievements page" do
          get :edit, params: { id: achievement }
          expect(response).to redirect_to(achievements_path)
        end
      end

      describe "PUT update" do
        it "redirects to achievements page" do
          put :update, params: { id: achievement,
                                 achievement: { title: "Updated title" } }
          expect(response).to redirect_to(achievements_path)
        end
      end

      describe "DELETE destroy" do
        it "redirects to achievements page" do
          delete :destroy, params: { id: achievement }
          expect(response).to redirect_to(achievements_path)
        end
      end
    end

    context "is the owner of the achievement" do
      before do
        allow(achievement).to receive(:user) { user }
        allow(Achievement).to receive(:find) { achievement }
      end

      describe "GET edit" do
        it "renders :edit template" do
          get :show, params: { id: achievement }
          expect(response).to render_template(:show)
        end

        it "assigns requested achievement to @achievement" do
          get :show, params: { id: achievement }
          expect(assigns(:achievement)).to eq(achievement)
        end
      end

      describe "PUT update" do
        let(:achievement_params) { ActionController::Parameters.new(title: "Updated Title").permit(:title) }

        it "sends update message to achievement" do
          expect(achievement).to receive(:update).with(achievement_params)
          put :update, params: { id: achievement, achievement: { title: "Updated Title"} }
        end

        context "achievement is updates" do
          before do
            expect(achievement).to receive(:update).with(achievement_params) { true }
          end

          it "redirects" do
            put :update, params: { id: achievement, achievement: { title: "Updated Title"} }
            expect(response).to redirect_to(achievement_path)
          end
        end

        context "achievement is not updated" do
          before do
            expect(achievement).to receive(:update).with(achievement_params) { false }
          end

          it "render :edit template" do
            put :update, params: { id: achievement, achievement: { title: "Updated Title"} }
            expect(response).to render_template(:edit)
          end

          it "assigns achievement to template" do
            put :update, params: { id: achievement, achievement: { title: "Updated Title"} }
            expect(assigns(:achievement)).to eq(achievement)
          end
        end
      end

      describe "DELETE destroy" do
        before do
          expect(achievement).to receive(:destroy)
        end
        it "sends delete message to achievement" do
          delete :destroy, params: { id: achievement }
        end

        it "redirects to achievements#index" do
          delete :destroy, params: { id: achievement }
          expect(response).to redirect_to(achievements_path)
        end
      end
    end
  end
end