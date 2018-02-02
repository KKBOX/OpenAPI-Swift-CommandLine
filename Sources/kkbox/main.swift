let tool = OpenAPICommandLineTool()

do {
	try tool.run()
} catch {
	Renderer.write(message: error.localizedDescription, to: .error)
}
