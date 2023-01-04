//
//  LoginView.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/28.
//

import SwiftUI
import PhotosUI

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
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    var body: some View {
        ZStack {
            if let selectedPhotoData,
                let image = UIImage(data: selectedPhotoData) {

                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            }
            VStack {
                VStack {
                    Image(systemName: "fork.knife")
                        .resizable()
                        .foregroundColor(.accentColor)
                        .frame(width: 100.0, height: 120.0)
                    Text("Restaurant Finder")
                        .font(.title2)
                        .foregroundColor(selectedPhotoData != nil ? .white : .black)
                        .fontWeight(.medium)
                        .padding(.bottom)
                    Text("Find what you want")
                        .font(.title2)
                        .foregroundColor(selectedPhotoData != nil ? .white : .blue)
                        .fontWeight(.medium)
                        
                }
                VStack{
                    TextField("name", text: $inputEmail)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .frame(width: 300.0)
                        .submitLabel(.next)
                        .padding()
                    SecureField("password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300.0)
                        .submitLabel(.return)
                        .padding()
                }
                
                
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
                PhotosPicker(selection: $selectedItem, matching: .any(of: [.images, .not(.livePhotos)])) {
                    Label("Select your backgroud", systemImage: "photo")
                }
                .padding(.top)
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedPhotoData = data
                        }
                    }
                }
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
    @State var grader = "男"
//    @State private var showWeclomeAlert = false
    @State private var welcomeName = "帥哥"
    let graders = ["男","女"]
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
                .frame(width: 300.0)
                .submitLabel(.next)
                .padding()
            SecureField("password", text: $password)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300.0)
                .submitLabel(.return)
                .padding()
            Picker(selection: $grader) {
                ForEach(graders, id: \.self) { item in
                    Text(item)
                }
                
            } label: {
                Text("性別")
            }
            .padding(.bottom)
            .frame(width: 100.0)
            .pickerStyle(.segmented)
            .onChange(of: grader) { newValue in
//                showWeclomeAlert = true
                welcomeName = grader == "男" ? "帥哥" : "小仙女"
            }
//            .alert("歡迎\(welcomeName)加入Restaurant Finder", isPresented: $showWeclomeAlert) {
//
//            }

            Button("Sign up"){
                user.creatUser(email: userEmail, password: password)
                showAlert = true
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .alert("歡迎\(userEmail)\(welcomeName)加入Restaurant Finder", isPresented: $showAlert) {
                Button("Ok", action: {
                    wantSignUP = false
                })
            }
        }
    }
}
