![256](https://user-images.githubusercontent.com/466656/217907554-6d732a98-8fb7-44a0-ae19-0dc25c682a4c.png)
> App Icon Courtesy of: [midjourney.com](https://midjourney.com)

# Tasks iOS App
This is an iOS application for creating, updating, and deleting simple task items.

## ⚡️ Quickstart
<img width="233" alt="Screenshot 2023-02-09 at 12 09 29 PM" src="https://user-images.githubusercontent.com/466656/217908348-f76cc7ff-f337-432b-b460-e0557306f6cd.png">

> With the workspace open in Xcode; Select the `TodoApp` scheme and your preferred device. Then hit run.

## 🎯 Features
- [x] User should be able to add a task
- [x] User should be able to edit a task
- [x] User should be able to remove a task
- [x] User should be able to mark a task as completed
- [x] Tasks that have been added but not completed should be displayed in black (white in dark mode) text
- [x] Tasks that have been added and completed should be displayed in red text
- [x] All tasks should be in 1 list ordered by the date they were added
- [x] The list of tasks should be shown on teh start of the app
- [x] The list of tasks should be persisted
- [x] Support Dark/Light mode
- [x] MVVM
- [x] SwiftUI or UIKit 👈 This example is using UIKit

### === Extra ===
- [x] All text is localized. Supported languages: 🇺🇸 🇲🇽
- [x] All text supports dynamic type
- [x] Features were created in TDD fasion to provide excellent test coverage

## 📲 Demo

https://user-images.githubusercontent.com/466656/217907472-e421154a-e4d5-49a5-9c4b-73256177e55e.mp4

## 📖 Definitions:

Task
: A paragraph of freeform text
> Note: In the app we use the term "Todo" instead of "Task". This is due to "Task" being an object type in Swift Concurrency.

## 💡 Project Architecture
<img width="1290" alt="diagram" src="https://user-images.githubusercontent.com/466656/217956547-97e10e53-88f9-4d40-9ac0-19b7f7c6cff4.png">


## 🤖 Test Coverage

<img width="586" alt="Screenshot 2023-02-09 at 12 00 05 PM" src="https://user-images.githubusercontent.com/466656/217908324-7ef2f426-dde6-4cc1-9697-485338b0189e.png">

## 📝 Notes
- The workspace is divided into two parts. `TodoEngine` and `TodoApp`. The engine drives the business logic and the app serves as the delivery system. Keeping the engine agnostic of any UI frameworks means that it can be easily used across systems.
- Commits were made directly to the main branch. In a consumer facing project, we would likely use feature branches and a PR strategy.
- The file manager was chosen to store persistent data. This was due to its simple setup when compared to alternatives like coredata.
- However, swapping the file manager for coredata is straight forward. Merely implement the `TodoStore` protocol and swap the `store` in `SceneDelegate` from `FileManagerTodoStore` to a new `CoreDataTodoStore` implementation.
- There's a CI_iOS Scheme in the project. However, CI has not (yet) been configured. We'll likely opt for using github actions.
- The UI was created programmatically. This is our preferred method since it avoids common merge conflicts found when using Storyboards.
- This project does not contain a tool for linting the codebase. However, we think it makes for a valuable addition.
- No additional code comments were added the project. The goal was to create clear implementations and test coverage to make the system easy to understand.


## 🌗 Light vs Dark

| Light | Dark |
| ----- | ----- |
|![EMPTY_TODOS_light](https://user-images.githubusercontent.com/466656/217914327-db34d399-f4cf-49f4-bf3f-d6817ced2f99.png)|![EMPTY_TODOS_dark](https://user-images.githubusercontent.com/466656/217914346-e5b8535b-82c9-4260-a718-ce4b6c63d3e0.png)|
|![TODOS_WITH_CONTENT_light](https://user-images.githubusercontent.com/466656/217914403-ecb46538-dd6c-4b2f-a2d9-a8f48fe42bd2.png)|![TODOS_WITH_CONTENT_dark](https://user-images.githubusercontent.com/466656/217914426-d05edafc-78ef-474b-b09d-bb84859f7ae5.png)|
|![TODOS_WITH_EMPTY_CONTENT_light](https://user-images.githubusercontent.com/466656/217914552-6577aee4-ce20-4cce-90cc-2fab1cf7f7ea.png)|![TODOS_WITH_EMPTY_CONTENT_dark](https://user-images.githubusercontent.com/466656/217914576-680e44e9-92f3-4e0b-a506-8202b5a40971.png)|

## 👁️ Dynamic Type

| Regular | Large |
| ----- | ----- |
| ![TODOS_WITH_CONTENT_light](https://user-images.githubusercontent.com/466656/217917901-2e360a93-2791-46d7-b3c2-e3068b96239f.png)|![TODOS_WITH_CONTENT_dark](https://user-images.githubusercontent.com/466656/217917941-162748cc-cb65-4d50-b1fa-9c8fa16a8a85.png)|

## 🇺🇸 🇲🇽 Localization

| English | Spanish |
| ----- | ----- |
|![RocketSim_Screenshot_iPhone_14_Pro_Max_2023-02-09_11 06 03](https://user-images.githubusercontent.com/466656/217911521-11f2df37-179a-451e-9a37-aaee3d9030fe.png)|![RocketSim_Screenshot_iPhone_14_Pro_Max_2023-02-09_11 05 26](https://user-images.githubusercontent.com/466656/217911535-720c6467-472c-4f79-a424-249888fb9e9e.png)|
|![RocketSim_Screenshot_iPhone_14_Pro_Max_2023-02-09_11 05 59](https://user-images.githubusercontent.com/466656/217911554-128994a4-c184-418a-b9e3-ced211e95020.png)|![RocketSim_Screenshot_iPhone_14_Pro_Max_2023-02-09_11 05 39](https://user-images.githubusercontent.com/466656/217911571-f23f2232-1a3b-4f16-8891-fe4d38649584.png)|
