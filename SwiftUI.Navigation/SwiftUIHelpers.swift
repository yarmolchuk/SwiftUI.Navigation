//
//  SwiftUIHelpers.swift
//  SwiftUI.Navigation
//
//  Created by Yarmolchuk on 13.08.2025.
//

import SwiftUI
import CasePaths

extension Binding {
    func isPresent<Wrapped>() -> Binding<Bool>
    where Value == Wrapped? {
        .init(
            get: {
                self.wrappedValue != nil
            },
            set: { isPresented in
                if !isPresented {
                    self.wrappedValue = nil
                }
            }
        )
    }
}

extension View {
    func alert<A: View, M: View, T>(
        title: (T) -> Text,
        presenting data: Binding<T?>,
        @ViewBuilder actions: @escaping (T) -> A,
        @ViewBuilder message: @escaping (T) -> M
    ) -> some View {
        self.alert(
            data.wrappedValue.map(title) ?? Text(""),
            isPresented: .init(
                get: { data.wrappedValue != nil },
                set: { if !$0 { data.wrappedValue = nil } }
            ),
            presenting: data.wrappedValue,
            actions: actions,
            message: message
        )
    }
    
    func alert<A: View, M: View, Enum, Case>(
        title: (Case) -> Text,
        unwrap data: Binding<Enum?>,
        case casePath: AnyCasePath<Enum, Case>,
        @ViewBuilder actions: @escaping (Case) -> A,
        @ViewBuilder message: @escaping (Case) -> M
    ) -> some View {
        alert(
            title: title,
            presenting: data.case(casePath),
            actions: actions,
            message: message
        )
    }
}

extension View {
    func confirmationDialog<A: View, M: View, T>(
        title: (T) -> Text,
        titleVisibility: Visibility = .automatic,
        presenting data: Binding<T?>,
        @ViewBuilder actions: @escaping (T) -> A,
        @ViewBuilder message: @escaping (T) -> M
    ) -> some View {
        self.confirmationDialog(
            data.wrappedValue.map(title) ?? Text(""),
            isPresented: .init(
                get: { data.wrappedValue != nil },
                set: { if !$0 { data.wrappedValue = nil } }
            ),
            titleVisibility: titleVisibility,
            presenting: data.wrappedValue,
            actions: actions,
            message: message
        )
    }
    
    func confirmationDialog<A: View, M: View, Enum, Case>(
        title: (Case) -> Text,
        unwrap data: Binding<Enum?>,
        case casePath: AnyCasePath<Enum, Case>,
        @ViewBuilder actions: @escaping (Case) -> A,
        @ViewBuilder message: @escaping (Case) -> M
    ) -> some View {
        confirmationDialog(
            title: title,
            presenting: data.case(casePath),
            actions: actions,
            message: message
        )
    }
}

struct IfCaseLet<Enum, Case, Content>: View where Content: View {
    let binding: Binding<Enum>
    let casePath: AnyCasePath<Enum, Case>
    let content: (Binding<Case>) -> Content
    
    init(
        _ binding: Binding<Enum>,
        pattern casePath: AnyCasePath<Enum, Case>,
        @ViewBuilder content: @escaping (Binding<Case>) -> Content
    ) {
        self.binding = binding
        self.casePath = casePath
        self.content = content
    }
    
    var body: some View {
        if let `case` = self.casePath.extract(from: self.binding.wrappedValue) {
            self.content(
                Binding(
                    get: { `case` },
                    set: { binding.wrappedValue = self.casePath.embed($0) }
                )
            )
        }
    }
}

extension Binding {
    init?(unwrap binding: Binding<Value?>) {
        guard let wrappedValue = binding.wrappedValue
        else { return nil }
        
        self.init(
            get: { wrappedValue },
            set: { binding.wrappedValue = $0 }
        )
    }
}

extension Binding {
    func didSet(_ callback: @escaping (Value) -> Void) -> Self {
        .init(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                callback($0)
            }
        )
    }
}

extension View {
    func sheet<Value, Content>(
        unwrap optionalValue: Binding<Value?>,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) -> some View where Value: Identifiable, Content: View {
        sheet(item: optionalValue) { _ in
            if let value = Binding(unwrap: optionalValue) {
                content(value)
            }
        }
    }
    
    func sheet<Enum, Case, Content>(
        unwrap item: Binding<Enum?>,
        `case` casePath: AnyCasePath<Enum, Case>,
        @ViewBuilder content: @escaping (Binding<Case>) -> Content
    ) -> some View where Case: Identifiable, Content: View {
        sheet(item: item.case(casePath)) { _ in
            if let value = Binding(unwrap: item.case(casePath)) {
                content(value)
            }
        }
    }
}

extension View {
    func popover<Value, Content>(
        unwrap item: Binding<Value?>,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) -> some View
    where Value: Identifiable, Content: View {
        popover(item: item) { _ in
            if let item = Binding(unwrap: item) {
                content(item)
            }
        }
    }
    
    func popover<Enum, Case, Content>(
        unwrap item: Binding<Enum?>,
        `case` casePath: AnyCasePath<Enum, Case>,
        @ViewBuilder content: @escaping (Binding<Case>) -> Content
    ) -> some View where Case: Identifiable, Content: View {
        popover(item: item.case(casePath)) { _ in
            if let value = Binding(unwrap: item.case(casePath)) {
                content(value)
            }
        }
    }
}

extension NavigationLink {
    init<Value, WrappedDestination>(
        unwrap optionalValue: Binding<Value?>,
        onNavigate: @escaping (Bool) -> Void,
        @ViewBuilder destination: @escaping (Binding<Value>) -> WrappedDestination,
        @ViewBuilder label: @escaping () -> Label
    )
    where Destination == WrappedDestination?
    {
        self.init(
            isActive: optionalValue.isPresent().didSet(onNavigate),
            destination: {
                if let value = Binding(unwrap: optionalValue) {
                    destination(value)
                }
            },
            label: label
        )
    }
    
    init<Enum, Case, WrappedDestination>(
        unwrap optionalValue: Binding<Enum?>,
        case casePath: AnyCasePath<Enum, Case>,
        onNavigate: @escaping (Bool) -> Void,
        @ViewBuilder destination: @escaping (Binding<Case>) -> WrappedDestination,
        @ViewBuilder label: @escaping () -> Label
    )
    where Destination == WrappedDestination?
    {
        self.init(
            unwrap: optionalValue.case(casePath),
            onNavigate: onNavigate,
            destination: destination,
            label: label
        )
    }
}
