//
//  PostView.swift
//  beraber
//
//  Created by yozdemir on 2.04.2022.
//

import SwiftUI
import ImageViewerRemote
import Firebase

struct PostView: View {
    
    @Binding var tabSelection: String
    @Binding var openMessageJoinModal: Bool
    @Binding var redirectingPostId: String
    @Binding var redirectingPosOwnerId: String
    @Binding var redirectingJoinCode: String
    @Binding var redirectingNewRoomTitle: String
    @StateObject var postData = PostViewModel()
    @State var openOtherUserProfile = false
    @State var postUserUid = ""
    @State var showPostImage: Bool = false
    @Binding var openNewPostView: Bool
    @State var previousPost: PostModel = PostModel(id: "", title: "", description: "", pic: "", time: Date(), hasChatroom: false, chatRoomCode: "0", chatRoomTitle: "", user: UserModel(uid: "", userProfilePic: "", userName: "", userBiography: "", userAge: 0, userLocation: "", userReasonForApp: "", phoneNumber: "", emailAddress: "", possibleDaysOfWeek: [""], showConnectionInfos: false, showPossibleDaysInfos: false, showAgeInfos: false, showLocationInfos: false, numberOfRooms: 0, userCreationDate: Timestamp(date: Date(timeIntervalSince1970: 0))))
    
    

    var body: some View {
        VStack{
            BeraberNavigationView(title: "Anasayfa", withTrailingIcon: false) { _ in }
            if postData.isLoading {
                Spacer(minLength: 0)
                ProgressView()
                Spacer(minLength: 0)
            } else {
                if postData.noPosts{
                    HStack {
                        Spacer(minLength: 0)
                        VStack {
                            Image("noPostMainPage")
                                .resizable()
                                .frame(width: 192, height: 152, alignment: .center)
                                .padding()
                            Text("Görünüşe göre yakınlarda hiçbir paylaşım yapılmadı. Hemen bir gönderi yayınlayarak, iyilik akımını başlatabilirsin.")
                                .font(.custom("", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.horizontal, 60)
                            Button {
                                postData.newPost.toggle()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                            }.padding(.top, 10)
                        }
                        .padding(.vertical, 10)
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical,60)
                    Spacer(minLength: 0)
                } else {
                    ScrollView(showsIndicators: false){
                        PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                            postData.getAllPosts()
                        }
                        VStack(spacing: 15){
                            ForEach(postData.posts){ post in
//                                if previousPost.id != post.id {
                                PostRow(tabSelection: $tabSelection, openMessageJoinModal: $openMessageJoinModal, redirectingPostId: $redirectingPostId,redirectingPosOwnerId: $redirectingPosOwnerId,redirectingJoinCode: $redirectingJoinCode, redirectingNewRoomTitle: $redirectingNewRoomTitle, postData: postData, openOtherUserProfile: $openOtherUserProfile, postUserUid: $postUserUid,showPostImage: $showPostImage, post: post)
//                                        .onAppear {
//                                        print("**********")
//                                        print("Onceki Post id : ",previousPost.id, " Şimdiki Post id: ", post.id)
//                                        previousPost = post
//                                    }
//                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 55)
                    }.coordinateSpace(name: "pullToRefresh")
                }
            }
        }
        .fullScreenCover(isPresented: $openNewPostView){
            NewPostView()
        }
        .onAppear(perform: {
                postData.getAllPosts()
        })
        .fullScreenCover(isPresented: $openOtherUserProfile, content: {
            OtherProfileView(tabSelection: $tabSelection,openMessageJoinModal: $openMessageJoinModal, redirectingPostId: $redirectingPostId,redirectingPosOwnerId: $redirectingPosOwnerId, redirectingJoinCode: $redirectingJoinCode, redirectingNewRoomTitle: $redirectingNewRoomTitle, profileData: OtherProfileViewModel(), openOtherUserProfile: $openOtherUserProfile, postUserUid: $postUserUid)
        })
        .fullScreenCover(isPresented: self.$showPostImage){
            ImageViewerRemote(imageURL: self.$postData.selectedPostImageUrl, viewerShown: self.$showPostImage)
                .background(Color(red: 0.12, green: 0.12, blue: 0.12, opacity: (1.0)))
        }
        .padding(18)
    }
}
