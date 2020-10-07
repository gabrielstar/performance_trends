describe('HTML tests', () => {
    it('should JMeter link be there!', () => {
        cy.visit('http://localhost:3000/tools')
        cy.contains('JMeter')
    })
})