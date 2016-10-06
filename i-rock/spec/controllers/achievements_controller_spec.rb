require "rails_helper"

describe AchievementsController do

  describe "guest user" do
    describe "GET index" do
      let(:achievement) { instance_double(Achievement) }

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
  end

  describe "authenticated user" do
    let(:user) { instance_double(User) }
    
    before do
      allow(controller).to receive(:authenticate_user!) { true }
      allow(controller).to receive(:current_user) { user }
    end

    describe "POST create" do
      # let(:achievement_params) { { title: "title" } }
      let(:achievement_params) { ActionController::Parameters.new(title: "title") }
      let(:params) { { title: "title" } }
      let(:create_achievement) { instance_double(CreateAchievement) }
      let(:achievement) { instance_double(Achievement) }

      before do
        allow(CreateAchievement).to receive(:new) { create_achievement }
        allow(create_achievement).to receive(:create)
        allow(create_achievement).to receive(:created?)
        allow(create_achievement).to receive(:achievement) { achievement }
      end

      it "sends create message to CreateAchievement" do
        expect(CreateAchievement).to receive(:new).with(achievement_params, user)
        # post :create, params: { achievement: achievement_params }
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
  end
end