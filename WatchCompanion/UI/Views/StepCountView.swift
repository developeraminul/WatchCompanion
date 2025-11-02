import SwiftUI

struct StepCountView: View {
    let feature: StepCounting
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "figure.walk")
                .foregroundColor(.purple)
                .font(.title2)
            
            Text("\(feature.stepCount)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.purple)
            
            Text("Steps")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(String(format: "%.1f km", feature.distance))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 120) // FIX: Consistent sizing
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4)
    }
}
