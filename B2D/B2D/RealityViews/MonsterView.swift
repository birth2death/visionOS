
import SwiftUI
import RealityKit
import RealityKitContent

struct MonsterView: View {
    @Environment(ViewModel.self) private var model
    @Environment(ModelData.self) var modelData
    //@State var monsterControls: MonsterControls?
    var monster: Monster3D?
    @State var index:Int = 0
    @State var content: RealityViewContent? = nil
    
    var body: some View {
        VStack{
            if let monster = monster {
                RealityView{
                    content in let contentCopy = content
                    Task {
                        do {
                            if let entity = await RealityKitContent.entity(named: monster.usdz_list[index]) {
                                contentCopy.add(entity)
                                if let animationKey = entity.availableAnimations.first {
                                    
                                    entity.playAnimation(animationKey.repeat(), transitionDuration: 0.3, startsPaused: false)
                                    
                                    print(type(of: contentCopy))
                                    
                                    self.content = contentCopy
                                    model.entity = entity
                                    birth()
                                    
                                }
                            }
                        }
//                        catch {
//                            Text("Entity is not exist.")
//                        }
                    }
                }
            } else {
                Text("Monster is not exist.").foregroundColor(.red)
            }
        }
    }
    @State var timer: Timer? = nil
    var change: Singularity? = Singularity.none
    
    func birth(){
        print("birth")
        
        guard
            model.inputTime.truncatingRemainder(dividingBy: 4) == 0 else{
            print("Error: inputTime 이 이상함.( 4로 나눌 수 없음.)")
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: model.inputTime / 4 , repeats: true) { _ in
            
            guard index+1 < monster?.usdz_list.count ?? 0 else {
                death()
                return
            }
            
            _ = self.monster?.usdz_list[index]
            
            Task {
                do {
                    let newMonster = await RealityKitContent.entity(named: monster!.usdz_list[index+1])
                    
                    
                    
                    DispatchQueue.main.async {
                        print(monster!.usdz_list[index])
                        self.content?.add(newMonster!)
                       
                        model.entity?.removeFromParent()
                        model.entity = newMonster
                        if let animationKey = model.entity?.availableAnimations.first {
                            
                            model.entity?.playAnimation(animationKey.repeat(), transitionDuration: 0.3, startsPaused: false)
                            
                        }
                        index += 1
                    }
                } 
//                catch {
//                    print("Error: cant load \(monster?.usdz_list[index])")
//                }
            }
        }
    }
    
    
    func death(){
        print("death")
        timer?.invalidate()
        timer = nil
        model.isShowingModule = false
    }
    
}

#Preview {
    let monster = ModelData().monster["shadow"]
    return MonsterView(monster:monster, index:0).environment(ModelData()).environment(ViewModel())
    
}
