require "spec_helper"

describe IssuesController do
  describe "routing" do

    it "routes to #index" do
      get("/issues/scope").should route_to("issues#index", :scope => 'scope')
    end

    it "routes to #new" do
      get("/").should route_to("issues#new")
    end

    it "routes to #show" do
      get("/1").should route_to("issues#show", :id => "1")
    end

    it "routes to #create" do
      post("/").should route_to("issues#create")
    end

  end
end
