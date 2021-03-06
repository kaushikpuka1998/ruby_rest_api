class Api::V1::UsersController < ApplicationController
    def facebook
        if params[:facebook_access_token]
            graph = Koala::Facebook::API.new params[:facebook_access_token]
            user_data = graph.get_object("me?fields=name,email,id,picture")
            user = User.find_by email: user_data['email']
            if user
                user.generate_unique_authentication_token
              
                json_response "User Information",true,{user: user},:ok
            else
                user = User.new (email =  user_data["email"],
                                uid = user_data["id"],
                                provider = "Facebook",
                                image = user_data["picture"]["data"]["url"],
                                password = Devise.friendly_token[0,20])

                user.authentication_token = User.generate_authentication_token
                    

                if user.save

                    json_response "Login Facebook Successfully",true,{user: user},:ok
                else

                    json_response user.errors,false,{},:unprocessable_entity

                end
            end
        else
            json_response "Missing Facebook Authentication token",false,{},:unprocessable_entity
        end
    end
end