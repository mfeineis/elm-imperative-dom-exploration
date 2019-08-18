/* global Elm */
const app = Elm.App.init({
    flags: {},
});

const root = document.querySelector("#root");

app.ports.render.subscribe(function (dom) {
    console.log("app.render into", root, dom);

    root.innerHTML = "";

    function render(node) {
        switch (node.type) {
            case "forEach": {
                const div = document.createElement("div");
                node.children.forEach(function (child) {
                    div.appendChild(render(child));
                });
                return div;
            }
            case "if": {
                return render(node.condition ? node.true : node.false);
            }
            case "node": {
                const domNode = document.createElement(node.tagName);
                node.attributes.forEach(function (attr) {
                    switch (attr.type) {
                    case "property":
                        domNode[attr.key] = attr.value;
                        break;
                    default:
                        throw new Error("Unknown attribute type '" + attr.type + "'");
                    }
                });
                node.children.forEach(function (child) {
                    const childNode = render(child);
                    domNode.appendChild(childNode);
                });
                return domNode;
            }
            case "text": {
                return document.createTextNode(node.value);
            }
            default:
                throw new Error("Unknown node type '" + node.type + "'");
        }
    }

    root.appendChild(render(dom));
});

