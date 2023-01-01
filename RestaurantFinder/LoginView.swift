//
//  LoginView.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/28.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var user : UserFunction
    @Binding var userEmail : String
    @State private var password = ""
    @State private var inputEmail = ""
    @State private var wantSignUp = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var loading = false
    @State private var find = false
    @Binding var login : Bool
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "fork.knife")
                    .resizable()
                    .foregroundColor(.accentColor)
                    .frame(width: 100.0, height: 120.0)
                Text("Restaurant Finder")
            }
            Text("Welcome")
            TextField("name", text: $inputEmail)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .submitLabel(.next)
                .padding()
            SecureField("password", text: $password)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.return)
                .padding()
            
            HStack {
                Button{
                    loading = true
                    user.login(email: inputEmail)
                    if !user.user.records.isEmpty {
                        find = true
                        userEmail = inputEmail
                        user.setEmail(email: inputEmail)
                    }
                    loading = false
                    if !user.Finding {
                        showAlert = true
                    }
                    
                    alertTitle = find ? "welcome" : "not found"
                } label:{
                    Text("Login")
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .alert(alertTitle, isPresented: $showAlert) {
                    if find {
                        Button("😋", action: {
                            login = true
                        })
                    } else {
                        Button("😨", action: {
                        })
                    }
                }
                Button{
                    wantSignUp = true
                } label: {
                    Text("Sign Up")
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .sheet(isPresented: $wantSignUp, content: {
                    SignUPView(wantSignUP: $wantSignUp)
                })
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(userEmail: .constant(String()), login: .constant(Bool()))
            .environmentObject(UserFunction())
    }
}

struct SignUPView: View {
    @EnvironmentObject var user : UserFunction
    @State private var userEmail = ""
    @State private var password = ""
    @State private var showAlert = false
    @Binding var wantSignUP : Bool
    var body: some View {
        return VStack {
            VStack {
                Image(systemName: "fork.knife")
                    .resizable()
                    .foregroundColor(.accentColor)
                    .frame(width: 100.0, height: 120.0)
                Text("Restaurant Finder")
            }
            Text("Welcome")
            TextField("name", text: $userEmail)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .submitLabel(.next)
                .padding()
            SecureField("password", text: $password)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.return)
                .padding()
            Button("Sign up"){
                user.creatUser(email: userEmail, password: password)
                showAlert = true
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .alert("註冊成功", isPresented: $showAlert) {
                Button("Ok", action: {
                    wantSignUP = false
                })
            }
        }
    }
}
