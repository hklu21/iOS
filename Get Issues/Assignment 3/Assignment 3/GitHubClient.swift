//
//  GitHubClient.swift
//  Assignment 3
//
//  Created by 卢恒宽 on 1/30/22.
//
import UIKit

import Foundation

struct GithubIssue: Codable {
    let title: String?
    let createdAt: String
    let body: String?
    let state: String
    let user: GitHubUser
}

struct GitHubUser:Codable {
    let login: String
}

class GitHubClient {
    static func fetchOpenIssues(completion: @escaping ([GithubIssue]?, Error?) -> Void) {
    
        // Set the URL
        let url = URL(string: "https://api.github.com/repos/liuzhuang13/DenseNet/issues?state=open")!
        
        // Create a data task
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
          
          guard let data = data, error == nil else {
            // If we are missing data, send back no data with an error
            DispatchQueue.main.async { completion(nil, error) }
            return
          }
          
          // Safely try to decode the JSON to our custom struct
          do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let issues = try decoder.decode([GithubIssue].self, from: data)

            // If we're successful, send back our releases with no error
            //
            //
            DispatchQueue.main.async { completion(issues, nil) }

          } catch (let parsingError) {
            DispatchQueue.main.async { completion(nil, parsingError) }
          }
        }
    
        // Start the task (it begins suspended)
        task.resume()
    }
    
    static func fetchClosedIssues(completion: @escaping ([GithubIssue]?, Error?) -> Void) {
    
        // Set the URL
        let url = URL(string: "https://api.github.com/repos/liuzhuang13/DenseNet/issues?state=closed")!
        
        // Create a data task
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
          
          guard let data = data, error == nil else {
            // If we are missing data, send back no data with an error
            DispatchQueue.main.async { completion(nil, error) }
            return
          }
          
          // Safely try to decode the JSON to our custom struct
          do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let issues = try decoder.decode([GithubIssue].self, from: data)

            // If we're successful, send back our releases with no error
            //
            //
            DispatchQueue.main.async { completion(issues, nil) }

          } catch (let parsingError) {
            DispatchQueue.main.async { completion(nil, parsingError) }
          }
        }
    
        // Start the task (it begins suspended)
        task.resume()
    }
    
    
}

