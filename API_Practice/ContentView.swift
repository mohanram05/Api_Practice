//
//  ContentView.swift
//  BrakingBadApi
//
//  Created by Mohanram M on 09/02/26.
//

import SwiftUI

struct Model : Codable,Identifiable
{
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: Address
    var phone:String
}
struct Address : Codable
{
    var street: String
    var city: String
}

struct ContentView: View {
    @State var users:[Model] = []
    
    var body: some View {
        VStack
        {
            Button("Fetch Data of 3 Users")
            {
                Task
                {
                    await fetchData(limit: 3)
                }
            }
            Button("Fetch Data of 10 Users")
            {
                Task
                {
                    await fetchData(limit: 10)
                }
            }
            List(users,id:\.id)
            { user in
                VStack
                {
                    Text("\(user.id)")
                    Text("\(user.name)")
                    Text("\(user.email)")
                    Text("\(user.address.city)")
                }
            
            }
        }
    }
    func fetchData(limit :Int) async
    {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else
        {
            print("Invalid url")
            return
        }
        do
        {
            let (data,_)=try await URLSession.shared.data(from: url)
            if let decodedData = try? JSONDecoder().decode([Model].self, from: data)
            {
                users = Array(decodedData.prefix(limit))
            }
        }
        catch
        {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
