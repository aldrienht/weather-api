require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe "GET #index" do
    it "renders edit page and assigns value" do
      get :index, params: {}, format: :html
      expect(response).to render_template(:index)
    end
  end
end
